# 2026-08-24T08:57:21.798162900
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.get_component(name="ADC_Platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../ADC_RTOS.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../ADC1_Wrapper.xsa")

status = platform.build()

platform = client.create_platform_component(name = "rtos_platform",hw_design = "$COMPONENT_LOCATION/../ADC_RTOS.xsa",os = "freertos",cpu = "ps7_cortexa9_0",domain_name = "freertos_ps7_cortexa9_0")

platform = client.get_component(name="rtos_platform")
status = platform.update_desc(desc="TTC0 timer enabled in vivado, RTOS for Telnet based ADC capture
")

domain = platform.get_domain(name="freertos_ps7_cortexa9_0")

status = domain.set_lib(lib_name="lwip220", path="C:\AMDDesignTools\2025.2\Vitis\data\embeddedsw\ThirdParty\sw_services\lwip220_v1_3")

status = domain.set_config(option = "lib", param = "lwip220_api_mode", value = "SOCKET_API", lib_name="lwip220")

status = domain.regenerate()

comp = client.create_app_component(name="adc_rtos",platform = "$COMPONENT_LOCATION/../rtos_platform/export/rtos_platform/rtos_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "freertos_hello_world")

client.delete_component(name="adc_rtos")

status = domain.set_config(option = "lib", param = "lwip220_debug", value = "true", lib_name="lwip220")

comp = client.create_app_component(name="rtosadcapp",platform = "$COMPONENT_LOCATION/../rtos_platform/export/rtos_platform/rtos_platform.xpfm",domain = "freertos_ps7_cortexa9_0",template = "empty_application")

status = platform.build()

comp = client.get_component(name="rtosadcapp")
comp.build()

comp = client.get_component(name="rtosadcapp")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["-lm"])

status = platform.build()

comp = client.get_component(name="rtosadcapp")
comp.build()

comp = client.get_component(name="rtosadcapp")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["-lm", "m"])

status = platform.build()

comp = client.get_component(name="rtosadcapp")
comp.build()

comp = client.get_component(name="rtosadcapp")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["m"])

status = platform.build()

comp = client.get_component(name="rtosadcapp")
comp.build()

status = domain.set_config(option = "lib", param = "lwip220_mem_size", value = "1048576", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_memp_n_pbuf", value = "128", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_memp_n_sys_timeout", value = "16", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_pbuf_pool_size", value = "512", lib_name="lwip220")

status = domain.regenerate()

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

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = domain.set_config(option = "lib", param = "lwip220_acd_debug", value = "true", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_dhcp", value = "true", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_dhcp", value = "false", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_socket_mode_thread_prio", value = "3", lib_name="lwip220")

status = platform.build()

status = platform.build()

comp.build()

platform = client.get_component(name="ADC_Platform")
status = platform.build()

comp = client.get_component(name="ADC_Capture")
comp.build()

