within TwinBlocks;
package Examples "Whole models built the TwinBlocks way; CI builds each into an FMU"
  extends Modelica.Icons.ExamplesPackage;

  model HeatPumpOnMeasuredWater "A water-to-water heat pump fed with measured water on both sides"
    // The platform feeds the compressor signal and each side's water in (temperature and flow)
    // and reads the water out, the power, the heat and the COP: every input and output a
    // TwinBlocks.Units type, every measured stream through Fluid.Supply. Its parameters' values
    // here are examples: a model that extends it names each value's source in its own
    // documentation, since a modifier cannot change a description.
    package Medium = Buildings.Media.Water;

    parameter Modelica.Units.SI.Power P_nominal(min = 1) = 2500 "Compressor's electric power at full signal";
    parameter Real etaCarnot(unit = "1", min = 0.1, max = 0.95) = 0.4 "Share of the Carnot COP it reaches";
    parameter TwinBlocks.Units.Temperature_degC sinkStart = 20 "Condenser water at the start";
    parameter TwinBlocks.Units.Temperature_degC sourceStart = 20 "Evaporator water at the start";

    input TwinBlocks.Units.Fraction compressor "Compressor signal, 0 to 1";
    input TwinBlocks.Units.Temperature_degC sinkIn "Water into the condenser";
    input TwinBlocks.Units.VolumeFlowRate_Lmin sinkFlow "Water flow through the condenser";
    input TwinBlocks.Units.Temperature_degC sourceIn "Water into the evaporator";
    input TwinBlocks.Units.VolumeFlowRate_Lmin sourceFlow "Water flow through the evaporator";
    output TwinBlocks.Units.Temperature_degC sinkOut "Water out of the condenser";
    output TwinBlocks.Units.Temperature_degC sourceOut "Water out of the evaporator";
    output TwinBlocks.Units.Power_kW power "Compressor's electric power";
    output TwinBlocks.Units.Power_kW heat "Heat into the condenser water";
    output TwinBlocks.Units.Ratio cop "Coefficient of performance";

  protected
    TwinBlocks.Fluid.SupplyLitres sinkSupply(redeclare package Medium = Medium);
    TwinBlocks.Fluid.SupplyLitres sourceSupply(redeclare package Medium = Medium);
    TwinBlocks.HeatPumps.WaterToWater pump(P_nominal = P_nominal, etaCarnot = etaCarnot, conStart = sinkStart, evaStart = sourceStart);
    TwinBlocks.Fluid.LeavingTemperature sinkLeaving(redeclare package Medium = Medium, m_flow_nominal = 0.5);
    TwinBlocks.Fluid.LeavingTemperature sourceLeaving(redeclare package Medium = Medium, m_flow_nominal = 0.5);
    TwinBlocks.Fluid.Return sinkReturn(redeclare package Medium = Medium);
    TwinBlocks.Fluid.Return sourceReturn(redeclare package Medium = Medium);
  equation
    sinkSupply.T = sinkIn;
    sinkSupply.V_flow = sinkFlow;
    sourceSupply.T = sourceIn;
    sourceSupply.V_flow = sourceFlow;
    pump.y = compressor;
    connect(sinkSupply.port, pump.con_a);
    connect(pump.con_b, sinkLeaving.port_a);
    connect(sinkLeaving.port_b, sinkReturn.port);
    connect(sourceSupply.port, pump.eva_a);
    connect(pump.eva_b, sourceLeaving.port_a);
    connect(sourceLeaving.port_b, sourceReturn.port);
    sinkOut = sinkLeaving.T;
    sourceOut = sourceLeaving.T;
    power = pump.power;
    heat = pump.heat;
    cop = pump.cop;
    annotation(experiment(StartTime = 0, StopTime = 3600, Interval = 10));
  end HeatPumpOnMeasuredWater;
end Examples;
