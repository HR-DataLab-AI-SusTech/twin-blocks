within TwinBlocks;
package HeatPumps "Heat pumps"
  extends Modelica.Icons.Package;

  model WaterToWater "A water-to-water heat pump as a Carnot machine, scaled by its compressor signal"
    // Buildings.Fluid.HeatPumps.Carnot_y: its COP is etaCarnot times the Carnot COP between the
    // condenser's and the evaporator's leaving temperatures; P_nominal sets its size. Below
    // m_flow_min of water on either side the compressor signal fades smoothly to zero, as the
    // rig's controls stop the compressor when a pump stops: with no water to take the heat, a
    // Carnot machine freezes its evaporator or boils its condenser.
    replaceable package MediumCon = Buildings.Media.Water "The condenser side's fluid";
    replaceable package MediumEva = Buildings.Media.Water "The evaporator side's fluid";
    parameter Modelica.Units.SI.Power P_nominal(min = 1) "Compressor's electric power at full signal";
    parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal = 5 "Condenser water's rise at nominal (a typical design value, assumed)";
    parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal = -5 "Evaporator water's drop at nominal (a typical design value, assumed)";
    // Below 0.1 the nominal COP falls under 1 at Buildings' nominal temperatures, and at 1 the
    // machine would be ideal: Carnot_y refuses both.
    parameter Real etaCarnot(unit = "1", min = 0.1, max = 0.95) = 0.4 "Share of the Carnot COP it reaches";
    parameter Modelica.Units.SI.MassFlowRate m_flow_min = 0.01 "Water flow below which the compressor stops (about 0.6 L/min, assumed)";
    parameter Modelica.Units.NonSI.Temperature_degC conStart = 20 "Condenser water at the start";
    parameter Modelica.Units.NonSI.Temperature_degC evaStart = 20 "Evaporator water at the start";
    Modelica.Blocks.Interfaces.RealInput y(unit = "1") "Compressor signal, 0 to 1";
    Modelica.Fluid.Interfaces.FluidPort_a con_a(redeclare package Medium = MediumCon) "Condenser in";
    Modelica.Fluid.Interfaces.FluidPort_b con_b(redeclare package Medium = MediumCon) "Condenser out";
    Modelica.Fluid.Interfaces.FluidPort_a eva_a(redeclare package Medium = MediumEva) "Evaporator in";
    Modelica.Fluid.Interfaces.FluidPort_b eva_b(redeclare package Medium = MediumEva) "Evaporator out";
    Modelica.Blocks.Interfaces.RealOutput power(unit = "kW") "Compressor's electric power";
    Modelica.Blocks.Interfaces.RealOutput heat(unit = "kW") "Heat into the condenser water";
    Modelica.Blocks.Interfaces.RealOutput cop(unit = "1") "Coefficient of performance";
  protected
    Buildings.Fluid.HeatPumps.Carnot_y machine(
      redeclare package Medium1 = MediumCon,
      redeclare package Medium2 = MediumEva,
      P_nominal = P_nominal,
      dTCon_nominal = dTCon_nominal,
      dTEva_nominal = dTEva_nominal,
      etaCarnot_nominal = etaCarnot,
      use_eta_Carnot_nominal = true,
      dp1_nominal = 1000 "a small pressure drop; the platform's models carry no pressures (assumed)",
      dp2_nominal = 1000 "the same, evaporator side",
      T1_start = conStart + 273.15,
      T2_start = evaStart + 273.15,
      energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  equation
    machine.y = y
      * Buildings.Utilities.Math.Functions.smoothHeaviside(con_a.m_flow - m_flow_min, m_flow_min / 2)
      * Buildings.Utilities.Math.Functions.smoothHeaviside(eva_a.m_flow - m_flow_min, m_flow_min / 2);
    connect(con_a, machine.port_a1);
    connect(machine.port_b1, con_b);
    connect(eva_a, machine.port_a2);
    connect(machine.port_b2, eva_b);
    power = machine.P / 1000;
    heat = machine.QCon_flow / 1000;
    cop = if machine.P > 1 then machine.QCon_flow / machine.P else 0;
  end WaterToWater;
end HeatPumps;
