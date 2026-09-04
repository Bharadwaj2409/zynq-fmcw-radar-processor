# 2026-09-03T18:15:47.530296400
import vitis

client = vitis.create_client()
client.set_workspace(path="zynq-fmcw-radar-processor")

platform = client.get_component(name="GPIO_platform")
status = platform.build()

comp = client.get_component(name="ADC_rtos")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Bitstream_Files/Hanning_Window.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

