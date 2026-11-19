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

  model SupplyLitres "A stream at a measured temperature and volume flow in L/min, into the circuit"
    // The lab's flow meters give L/min; the mass flow is that volume at the stream's density.
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "The fluid";
    Modelica.Blocks.Interfaces.RealInput T(unit = "degC") "Its temperature";
    Modelica.Blocks.Interfaces.RealInput V_flow(unit = "L/min") "Its volume flow";
    Modelica.Fluid.Interfaces.FluidPort_b port(redeclare package Medium = Medium) "Into the circuit";
  protected
    Supply supply(redeclare package Medium = Medium);
  equation
    supply.T = T;
    supply.m_flow = V_flow / 60000 * Medium.density(Medium.setState_pTX(Medium.p_default, T + 273.15, Medium.X_default));
    connect(supply.port, port);
  end SupplyLitres;

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
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal flow; it sets only the sensor's regularisation near zero flow";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium);
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium);
    Modelica.Blocks.Interfaces.RealOutput T(unit = "degC") "The stream's temperature";
  protected
    // Flow one way only: a sensor that responds at once is sound at zero flow without reversal
    // (Buildings' Sensors.UsersGuide).
    Buildings.Fluid.Sensors.TemperatureTwoPort sensor(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, tau = 0, allowFlowReversal = false);
  equation
    connect(port_a, sensor.port_a);
    connect(sensor.port_b, port_b);
    T = sensor.T - 273.15;
  end LeavingTemperature;
end Fluid;
