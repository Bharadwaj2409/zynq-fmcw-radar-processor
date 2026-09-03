# 2026-09-03T09:38:32.556311400
import vitis

client = vitis.create_client()
client.set_workspace(path="zynq-fmcw-radar-processor")

platform = client.get_component(name="GPIO_platform")
status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radar1.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../final.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../final.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radargen.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radargen.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radargen.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

comp = client.create_app_component(name="new",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="new")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="new")
comp.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../radargen.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp = client.get_component(name="new")
comp.build()

status = platform.build()

comp.build()

client.delete_component(name="new")

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa")

status = platform.build()

comp = client.create_app_component(name="app",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

status = platform.build()

comp = client.get_component(name="app")
comp.build()

comp = client.get_component(name="app")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="app")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Bitstream_Files/Hanning_Window.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

vitis.dispose()

