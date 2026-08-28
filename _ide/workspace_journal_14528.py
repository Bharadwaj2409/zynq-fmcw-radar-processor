# 2026-08-27T09:16:55.056681100
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.get_component(name="GPIO_platform")
status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

vitis.dispose()

