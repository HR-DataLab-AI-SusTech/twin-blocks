within;
package TwinBlocks "The building blocks a model for the twin platform is made of"
  extends Modelica.Icons.Package;

  package UsersGuide "How a model meets the platform"
    extends Modelica.Icons.Information;
    annotation(Documentation(info = "<html>
<p>A model the platform runs is one Modelica class exported as an FMU. These are the rules every
model made from TwinBlocks follows, so a kind can declare it and a scenario can feed it.</p>
<ol>
<li><b>What the platform feeds is a top-level <code>input</code>, what it reads a top-level
<code>output</code></b>, each a <code>Real</code> of a type in <code>TwinBlocks.Units</code>: its unit
is the one the kind declares for the channel (<code>degC</code>, <code>kW</code>, <code>kW.h</code>,
<code>kg/s</code>, <code>1</code>).</li>
<li><b>A run's parameter is a top-level <code>parameter</code></b> with a unit and a description,
which the run dialog shows; a value fixed for the model goes under <code>protected</code>.</li>
<li><b>A measured fluid stream enters through <code>Fluid.Supply</code></b> (a temperature and a
flow from the platform) and leaves through <code>Fluid.Return</code>; a temperature the platform
reads is a <code>Fluid.LeavingTemperature</code>.</li>
<li><b>A table goes in the package's <code>Resources/</code></b> and is read through
<code>Modelica.Utilities.Files.loadResource</code>, so the FMU carries it.</li>
<li><b>Every parameter's value names its source</b> in its description or, for a value a
model sets on a block it extends, in the model's documentation: a datasheet, a measurement, an
assumption.</li>
</ol>
<p><code>Examples</code> holds whole models built this way; CI builds each into an FMU.</p>
</html>"));
  end UsersGuide;

  annotation(version = "0.1.0", uses(Modelica(version = "4.1.0"), Buildings(version = "14.0.0")),
    Documentation(info = "<html><p>TwinBlocks: units, fluid adapters and the lab's components, so
every model for the twin platform is built the same way. See <code>UsersGuide</code>.</p></html>"));
end TwinBlocks;
