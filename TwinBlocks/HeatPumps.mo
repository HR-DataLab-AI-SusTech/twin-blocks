within TwinBlocks;
package HeatPumps "Heat pumps"
  extends Modelica.Icons.Package;

  model WaterToWater "A water-to-water heat pump as a Carnot machine, scaled by its compressor signal"
    // Buildings.Fluid.HeatPumps.Carnot_y: its COP is etaCarnot times the Carnot COP between the
    // condenser's and the evaporator's leaving temperatures; P_nominal sets its size.
    replaceable package MediumCon = Buildings.Media.Water "The condenser side's fluid";
    replaceable package MediumEva = Buildings.Media.Water "The evaporator side's fluid";
    parameter Modelica.Units.SI.Power P_nominal "Compressor's electric power at full signal";
    parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal = 5 "Condenser water's rise at nominal";
    parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal = -5 "Evaporator water's drop at nominal";
    parameter Real etaCarnot(min = 0, max = 1) = 0.4 "Share of the Carnot COP it reaches";
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
      dp1_nominal = 1000,
      dp2_nominal = 1000,
      energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  equation
    machine.y = y;
    connect(con_a, machine.port_a1);
    connect(machine.port_b1, con_b);
    connect(eva_a, machine.port_a2);
    connect(machine.port_b2, eva_b);
    power = machine.P / 1000;
    heat = machine.QCon_flow / 1000;
    cop = if machine.P > 1 then machine.QCon_flow / machine.P else 0;
  end WaterToWater;
end HeatPumps;
