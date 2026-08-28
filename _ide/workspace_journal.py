# 2026-08-28T13:13:07.703900700
import vitis

client = vitis.create_client()
client.set_workspace(path="project_1")

comp = client.create_hls_component(name = "RADAR_ramp",cfg_file = ["hls_config.cfg"],template = "empty_hls_component")

cfg = client.get_config_file(path="C:\Users\vempa\Eclypse-Z7\project_1\RADAR_ramp\hls_config.cfg")

cfg.set_values(key="syn.file", values=["fmcw_ramp_gen.h"])

cfg.set_values(key="syn.file", values=["fmcw_ramp_gen.h", "fmcw_ramp_gen.cpp"])

cfg.set_values(key="tb.file", values=["tb_fmcw_ramp_gen.cpp"])

comp = client.get_component(name="RADAR_ramp")
comp.run(operation="C_SIMULATION")

cfg = client.get_config_file(path="/c:/Users/vempa/Eclypse-Z7/project_1/RADAR_ramp/hls_config.cfg")

cfg.set_value(section="hls", key="syn.top", value="fmcw_ramp_gen")

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

comp.run(operation="PACKAGE")

comp.run(operation="IMPLEMENTATION")

