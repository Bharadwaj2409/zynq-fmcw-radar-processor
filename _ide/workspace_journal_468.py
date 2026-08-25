# 2026-08-25T09:55:31.934113100
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.create_platform_component(name = "GPIO_platform",hw_design = "$COMPONENT_LOCATION/../ADC_GPIO.xsa",os = "freertos",cpu = "ps7_cortexa9_0",domain_name = "freertos_ps7_cortexa9_0")

platform = client.get_component(name="GPIO_platform")
status = platform.build()

domain = platform.get_domain(name="freertos_ps7_cortexa9_0")

status = domain.set_lib(lib_name="lwip220", path="C:\AMDDesignTools\2025.2\Vitis\data\embeddedsw\ThirdParty\sw_services\lwip220_v1_3")

status = domain.set_config(option = "lib", param = "lwip220_acd_debug", value = "true", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_api_mode", value = "SOCKET_API", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_debug", value = "true", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_dhcp", value = "true", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_dhcp_debug", value = "true", lib_name="lwip220")

status = platform.build()

status = domain.set_config(option = "lib", param = "lwip220_pbuf_pool_size", value = "2048", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_lwip_dhcp_does_acd_check", value = "true", lib_name="lwip220")

status = platform.build()

status = platform.build()

comp = client.create_app_component(name="ADC_rtos",platform = "$COMPONENT_LOCATION/../GPIO_platform/export/GPIO_platform/GPIO_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_lwip_echo_server")

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = domain.set_config(option = "lib", param = "lwip220_acd_debug", value = "false", lib_name="lwip220")

status = platform.build()

status = domain.set_config(option = "lib", param = "lwip220_debug", value = "false", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_dhcp_debug", value = "false", lib_name="lwip220")

status = platform.build()

status = platform.build()

comp.build()

comp = client.get_component(name="ADC_rtos")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["lm"])

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

comp = client.get_component(name="ADC_rtos")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["lm", "m"])

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

comp = client.get_component(name="ADC_rtos")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = comp.clean()

status = platform.build()

comp.build()

comp = client.get_component(name="ADC_rtos")
comp.set_app_config(key = "USER_LINK_OTHER_FLAGS", values = ["m"])

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = platform.build()

comp.build()

comp = client.get_component(name="ADC_rtos")
comp.set_app_config(key = "USER_LINK_OTHER_FLAGS", values = [""])

status = platform.build()

comp = client.get_component(name="ADC_rtos")
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

vitis.dispose()

