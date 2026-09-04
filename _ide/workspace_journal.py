# 2026-09-04T15:31:16.144544800
import vitis

client = vitis.create_client()
client.set_workspace(path="zynq-fmcw-radar-processor")

client.delete_component(name="app")

client.delete_component(name="componentName")

client.delete_component(name="app1")

client.delete_component(name="componentName")

platform = client.get_component(name="GPIO_platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../wraps.xsa")

status = platform.build()

comp = client.create_app_component(name="app",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="app")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="app")
comp.build()

client.delete_component(name="app")

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../wrapio.xsa")

status = platform.build()

comp = client.create_app_component(name="app",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="app")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="app")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../wrapman.xsa")

status = platform.build()

comp = client.create_app_component(name="appio",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="appio")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="appio")
comp.build()

client.delete_component(name="appio")

client.delete_component(name="app")

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../newone.xsa")

status = platform.build()

comp = client.create_app_component(name="ttapp",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="ttapp")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="ttapp")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../cool.xsa")

status = platform.build()

client.delete_component(name="ttapp")

comp = client.create_app_component(name="app1",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="app1")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="app1")
comp.build()

comp = client.clone_component(name="app1",new_name="TxRx")

status = platform.build()

comp = client.get_component(name="TxRx")
comp.build()

status = platform.build()

comp.build()

client.delete_component(name="app1")

