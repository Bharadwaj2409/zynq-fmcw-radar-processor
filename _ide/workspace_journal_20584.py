# 2026-08-26T08:57:47.418723600
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.get_component(name="GPIO_platform")
status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = platform.build()

comp.build()

