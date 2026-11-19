within TwinBlocks;
package Fluid "Where a measured fluid stream meets the model"
  extends Modelica.Icons.Package;

  model Supply "A stream at a measured temperature and flow, into the circuit"
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "The fluid";
    Modelica.Blocks.Interfaces.RealInput T(unit = "degC") "Its temperature";
    Modelica.Blocks.Interfaces.RealInput m_flow(unit = "kg/s") "Its mass flow";
    Modelica.Fluid.Interfaces.FluidPort_b port(redeclare package Medium = Medium) "Into the circuit";
  protected
    Buildings.Fluid.Sources.MassFlowSource_T source(redeclare package Medium = Medium, use_T_in = true, use_m_flow_in = true, nPorts = 1);
  equation
    source.T_in = T + 273.15;
    source.m_flow_in = m_flow;
    connect(source.ports[1], port);
  end Supply;

  model Return "The circuit's end, at a fixed pressure"
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "The fluid";
    Modelica.Fluid.Interfaces.FluidPort_a port(redeclare package Medium = Medium) "Out of the circuit";
  protected
    Buildings.Fluid.Sources.Boundary_pT sink(redeclare package Medium = Medium, nPorts = 1);
  equation
    connect(port, sink.ports[1]);
  end Return;

  model LeavingTemperature "The temperature of the stream passing, in degC"
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "The fluid";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal flow, for the sensor's regularisation";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium);
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium);
    Modelica.Blocks.Interfaces.RealOutput T(unit = "degC") "The stream's temperature";
  protected
    Buildings.Fluid.Sensors.TemperatureTwoPort sensor(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, tau = 0);
  equation
    connect(port_a, sensor.port_a);
    connect(sensor.port_b, port_b);
    T = sensor.T - 273.15;
  end LeavingTemperature;
end Fluid;
