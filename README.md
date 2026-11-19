# TwinBlocks

The Modelica building blocks a model for the lab's
[twin platform](https://dtp.twinhub.nl) is made of, so every model is built the same way: the
platform feeds it and reads it through the same kinds of inputs and outputs, a measured stream
enters it the same way, and a parameter says where its value comes from.

A model's repository starts from the
[Modelica model template](https://github.com/HR-DataLab-AI-SusTech/modelica-model-template) and
adds TwinBlocks and the Buildings library it builds on to its `model.toml`, each at a commit,
beside the template's Standard Library:

```toml
# LBNL's Modelica Buildings Library 14.0.0, the commit OpenModelica's library index names.
[libraries.Buildings]
git = "https://github.com/lbl-srg/modelica-buildings.git"
commit = "ad48324b74e9751e2e49dac5fe3c4dcb546755a2"

[libraries.TwinBlocks]
git = "https://github.com/HR-DataLab-AI-SusTech/twin-blocks.git"
commit = "<a commit of this repository>"
```

and `uses(Buildings(version = "14.0.0"), TwinBlocks(version = "0.1.0"))` in its package's
annotation. The build fetches them and runs with no network, so a library missing from
`model.toml` fails it.

## The standard

`TwinBlocks.UsersGuide` holds it; in short:

1. **What the platform feeds is a top-level `input`, what it reads a top-level `output`**, each of
   a type in `TwinBlocks.Units` (`Temperature_degC`, `Power_kW`, `Energy_kWh`, `MassFlowRate`,
   `VolumeFlowRate_Lmin`, `Fraction`, `Ratio`, `Pressure_bar`, `TemperatureDifference_K`,
   `Speed_rpm`), whose unit is the one the kind declares for the channel.
2. **A run's parameter is a top-level `parameter`** with a unit and a description; a value fixed
   for the model goes under `protected`.
3. **A state's start the platform may set is a parameter named `...Start`**, in its unit, so
   nothing starts at a library's default unannounced.
4. **A measured stream enters through `Fluid.Supply`** (a mass flow) or `Fluid.SupplyLitres` (a
   volume flow in L/min, as the lab's meters give it) and leaves through `Fluid.Return`; a
   temperature the platform reads is a `Fluid.LeavingTemperature`.
5. **A table goes in the package's `Resources/`**, read through `loadResource`, so the FMU
   carries it.
6. **Every parameter's value names its source**: a datasheet, a measurement or an assumption.

## The blocks

| Package | Blocks |
| --- | --- |
| `Units` | the unit types the platform's kinds use, `L/min` among them |
| `Fluid` | `Supply`, `SupplyLitres`, `Return`, `LeavingTemperature`: where a measured stream meets a model |
| `HeatPumps` | `WaterToWater`: a heat pump as a Carnot machine scaled by its compressor signal (Buildings' `Carnot_y`); it stops when either side's water stops |
| `Storage` | `Tank`: a fully mixed water tank that loses heat to its surroundings |
| `Examples` | `HeatPumpOnMeasuredWater`: a whole model built the TwinBlocks way |

They build on the [Modelica Standard Library](https://github.com/modelica/ModelicaStandardLibrary)
4.1.0 (OpenModelica's distribution) and LBNL's
[Buildings](https://github.com/lbl-srg/modelica-buildings) 14.0.0, pinned by commit in
`model.toml`.

## Its CI

Every push checks every concrete class in OpenModelica (`scripts/check_classes.py`), builds
`Examples.HeatPumpOnMeasuredWater` into an FMU with the template's `scripts/model.py`, steps it
against `reference/` and prints its kind entry: the classes compile, and the example answers as
it did. A change that changes an answer rewrites the
reference (`scripts/model.py test --write`) in the same commit, with the reason.

## Licence

Apache-2.0.
