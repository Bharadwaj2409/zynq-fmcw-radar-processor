# 2026-08-24T15:09:14.255264300
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.get_component(name="ADC_Platform")
status = platform.build()

comp = client.get_component(name="ADC_Capture")
comp.build()

vitis.dispose()

