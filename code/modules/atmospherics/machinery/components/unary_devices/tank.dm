#define AIR_CONTENTS	((25*ONE_ATMOSPHERE)*(air_contents.volume)/(R_IDEAL_GAS_EQUATION*air_contents.temperature))
/obj/machinery/atmospherics/components/unary/tank
	icon = 'icons/obj/atmospherics/pipes/pressure_tank.dmi'
	icon_state = "generic"

	name = "pressure tank"
	desc = "A large vessel containing pressurized gas."

	max_integrity = 800
	density = TRUE
	layer = ABOVE_WINDOW_LAYER
	pipe_flags = PIPING_ONE_PER_TURF
	
	var/datum/gas_mixture/air_contents
	var/volume = 10000 //in liters
	var/gas_type

/obj/machinery/atmospherics/components/unary/tank/Initialize()
	. = ..()
	air_contents = new
	air_contents.volume = volume
	air_contents.temperature = T20C
	create_gas()
	setPipingLayer(piping_layer)
	
/obj/machinery/atmospherics/components/unary/tank/proc/create_gas()
	if(gas_type)
		air_contents.assert_gas(gas_type)
		air_contents.gases[gas_type][MOLES] = AIR_CONTENTS
		name = "[name] ([air_contents.gases[gas_type][GAS_META][META_GAS_NAME]])"
	
/obj/machinery/atmospherics/components/unary/tank/attackby(obj/item/I, mob/user, params)
	if(!on)
	if(default_change_direction_wrench(user, I))
		return
	return ..()
	
/obj/machinery/atmospherics/components/unary/tank/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	SetInitDirections()
	var/obj/machinery/atmospherics/node = nodes[1]
	if(node)
		node.disconnect(src)
		nodes[1] = null
	nullifyPipenet(parents[1])

	atmosinit()
	node = nodes[1]
	if(node)
		node.atmosinit()
		node.addMember(src)
	build_network()
	return TRUE

/obj/machinery/atmospherics/components/unary/tank/air
	icon_state = "grey"
	name = "pressure tank (Air)"

/obj/machinery/atmospherics/components/unary/tank/air/create_gas()
	..()
	air_contents.assert_gases(/datum/gas/oxygen, /datum/gas/nitrogen)
	air_contents.gases[/datum/gas/oxygen][MOLES] = AIR_CONTENTS * O2STANDARD 
	air_contents.gases[/datum/gas/nitrogen][MOLES] = AIR_CONTENTS * N2STANDARD 

/obj/machinery/atmospherics/components/unary/tank/carbon_dioxide
	gas_type = /datum/gas/carbon_dioxide

/obj/machinery/atmospherics/components/unary/tank/toxins
	icon_state = "orange"
	gas_type = /datum/gas/plasma

/obj/machinery/atmospherics/components/unary/tank/oxygen
	icon_state = "blue"
	gas_type = /datum/gas/oxygen

/obj/machinery/atmospherics/components/unary/tank/nitrogen
	icon_state = "red"
	gas_type = /datum/gas/nitrogen
