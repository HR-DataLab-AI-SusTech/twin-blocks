within TwinBlocks;
package Units "The units a kind declares for its channels, as Modelica types"
  extends Modelica.Icons.TypesPackage;
  type Temperature_degC = Modelica.Units.NonSI.Temperature_degC "A temperature in degC";
  type Power_kW = Real(final quantity = "Power", final unit = "kW") "A power in kW";
  type Energy_kWh = Real(final quantity = "Energy", final unit = "kW.h") "An energy in kWh";
  type MassFlowRate = Modelica.Units.SI.MassFlowRate "A mass flow in kg/s";
  type VolumeFlowRate_Lmin = Real(final quantity = "VolumeFlowRate", final unit = "L/min") "A volume flow in L/min, as the lab's flow meters give it";
  type Fraction = Real(final unit = "1", min = 0, max = 1) "A signal or share from 0 to 1";
  type Ratio = Real(final unit = "1") "A ratio, such as a COP";
  type Pressure_bar = Real(final quantity = "Pressure", final unit = "bar") "A pressure in bar, as the rig's transducers give it";
  type TemperatureDifference_K = Real(final quantity = "ThermodynamicTemperature", final unit = "K") "A temperature difference in K, such as a superheat";
  type Speed_rpm = Real(final quantity = "AngularVelocity", final unit = "1/min") "A rotational speed in rpm, such as a compressor's";
end Units;
