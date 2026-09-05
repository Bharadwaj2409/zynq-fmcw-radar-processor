# 2026-09-05T09:08:20.170818400
import vitis

client = vitis.create_client()
client.set_workspace(path="zynq-fmcw-radar-processor")

comp = client.create_app_component(name="Vtune_Rx",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

comp = client.get_component(name="Vtune_Rx")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

platform = client.get_component(name="GPIO_platform")
status = platform.build()

comp = client.get_component(name="Vtune_Rx")
comp.build()

client.delete_component(name="TxRx")

client.delete_component(name="componentName")

status = platform.build()

comp.build()

domain = platform.get_domain(name="freertos_ps7_cortexa9_0")

status = domain.set_config(option = "lib", param = "lwip220_mem_size", value = "2097152", lib_name="lwip220")

status = domain.regenerate()

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../FasterADC.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

