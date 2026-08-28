# 2026-08-28T09:12:32.127395600
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

platform = client.get_component(name="GPIO_platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../adc100.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Hanning_Window.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

vitis.dispose()

