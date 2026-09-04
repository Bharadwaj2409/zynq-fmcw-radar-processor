# 2026-09-04T09:11:11.433584600
import vitis

client = vitis.create_client()
client.set_workspace(path="zynq-fmcw-radar-processor")

platform = client.get_component(name="GPIO_platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Bitstream_Files/design_1_wrapper.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="app")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../wrapper.xsa")

status = platform.build()

comp = client.create_app_component(name="app1",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

status = platform.build()

comp = client.get_component(name="app1")
comp.build()

status = platform.build()

comp.build()

comp = client.get_component(name="app1")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="app1")
comp.build()

vitis.dispose()

