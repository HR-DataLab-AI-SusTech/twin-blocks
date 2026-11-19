within TwinBlocks;
package Units "The units a kind declares for its channels, as Modelica types"
  extends Modelica.Icons.TypesPackage;
  type Temperature_degC = Modelica.Units.NonSI.Temperature_degC "A temperature in degC";
  type Power_kW = Real(final quantity = "Power", final unit = "kW") "A power in kW";
  type Energy_kWh = Real(final quantity = "Energy", final unit = "kW.h") "An energy in kWh";
  type MassFlowRate = Modelica.Units.SI.MassFlowRate "A mass flow in kg/s";
  type Fraction = Real(final unit = "1", min = 0, max = 1) "A signal or share from 0 to 1";
  type Ratio = Real(final unit = "1") "A ratio, such as a COP";
end Units;
