set_global_assignment -entity "ocd" -library "lib_ocd" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ocd" -library "lib_ocd" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "ocd" -library "lib_ocd" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ocd" -name SPD_FILE [file join $::quartus(sip_path) "../ocd.spd"]
set_global_assignment -library "lib_ocd" -name MISC_FILE [file join $::quartus(sip_path) "../../ocd.qsys"]

set_global_assignment -library "lib_ocd" -name MISC_FILE [file join $::quartus(sip_path) "ocd.v"]
set_global_assignment -library "lib_ocd" -name MISC_FILE [file join $::quartus(sip_path) "submodules/sld_signaltap.v"]
