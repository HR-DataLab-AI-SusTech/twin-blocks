within TwinBlocks;
package Storage "Water stores"
  extends Modelica.Icons.Package;

  model Tank "A fully mixed tank that loses heat to its surroundings"
    replaceable package Medium = Buildings.Media.Water "The fluid";
    parameter Modelica.Units.SI.Volume V "Volume";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal flow through it";
    parameter Modelica.Units.SI.ThermalConductance UA = 2 "Heat loss to the surroundings per kelvin (a small insulated tank, assumed)";
    parameter Modelica.Units.NonSI.Temperature_degC T_start = 20 "Water temperature at the start";
    parameter Modelica.Units.NonSI.Temperature_degC T_ambient = 20 "Surroundings' temperature";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "In";
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "Out";
    Modelica.Blocks.Interfaces.RealOutput T(unit = "degC") "Water temperature";
  protected
    Buildings.Fluid.MixingVolumes.MixingVolume volume(redeclare package Medium = Medium, V = V, m_flow_nominal = m_flow_nominal, nPorts = 2, T_start = T_start + 273.15, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss(G = UA);
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature surroundings(T = T_ambient + 273.15);
  equation
    connect(port_a, volume.ports[1]);
    connect(volume.ports[2], port_b);
    connect(volume.heatPort, loss.port_a);
    connect(loss.port_b, surroundings.port);
    T = volume.T - 273.15;
  end Tank;
end Storage;
