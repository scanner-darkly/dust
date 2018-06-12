local ControlSpec = require 'controlspec'
local Formatters = require 'jah/formatters'
local Gong = {}

-- Autogenerated using Engine_Gong.generateLuaEngineModuleSpecsSection

local specs = {}

specs.timbre = ControlSpec.new(0, 5, "linear", 0, 1, "")
specs.timemod = ControlSpec.new(1, 5, "linear", 0, 1, "")
specs.osc1gain = ControlSpec.AMP
specs.osc1partial = ControlSpec.new(0.5, 12, "linear", 0.5, 1, "")
specs.osc1fixed = ControlSpec.new(0, 1, "linear", 1, 0, "")
specs.osc1fixedfreq = ControlSpec.WIDEFREQ
specs.osc1index = ControlSpec.new(0, 24, "linear", 0, 3, "")
specs.osc1outlevel = ControlSpec.AMP
specs.osc1_to_osc1freq = ControlSpec.AMP
specs.osc1_to_osc2freq = ControlSpec.AMP
specs.osc1_to_osc3freq = ControlSpec.AMP
specs.osc2gain = ControlSpec.AMP
specs.osc2partial = ControlSpec.new(0.5, 12, "linear", 0.5, 1, "")
specs.osc2fixed = ControlSpec.new(0, 1, "linear", 1, 0, "")
specs.osc2fixedfreq = ControlSpec.WIDEFREQ
specs.osc2index = ControlSpec.new(0, 24, "linear", 0, 3, "")
specs.osc2outlevel = ControlSpec.AMP
specs.osc2_to_osc1freq = ControlSpec.AMP
specs.osc2_to_osc2freq = ControlSpec.AMP
specs.osc2_to_osc3freq = ControlSpec.AMP
specs.osc3gain = ControlSpec.AMP
specs.osc3partial = ControlSpec.new(0.5, 12, "linear", 0.5, 1, "")
specs.osc3fixed = ControlSpec.new(0, 1, "linear", 1, 0, "")
specs.osc3fixedfreq = ControlSpec.WIDEFREQ
specs.osc3index = ControlSpec.new(0, 24, "linear", 0, 3, "")
specs.osc3outlevel = ControlSpec.AMP
specs.osc3_to_osc3freq = ControlSpec.AMP
specs.osc3_to_osc2freq = ControlSpec.AMP
specs.osc3_to_osc1freq = ControlSpec.AMP
specs.filtermode = ControlSpec.new(0, 5, "linear", 1, 0, "")
specs.filtercutoff = ControlSpec.new(20, 10000, "exp", 0, 10000, "Hz")
specs.filterres = ControlSpec.UNIPOLAR
specs.ampgain = ControlSpec.AMP
specs.lforate = ControlSpec.new(0.125, 8, "exp", 0, 1, "Hz")
specs.lfo_to_filtercutoff = ControlSpec.BIPOLAR
specs.lfo_to_filterres = ControlSpec.BIPOLAR
specs.lfo_to_ampgain = ControlSpec.BIPOLAR
specs.lfo_to_osc1freq = ControlSpec.BIPOLAR
specs.lfo_to_osc2freq = ControlSpec.BIPOLAR
specs.lfo_to_osc3freq = ControlSpec.BIPOLAR
specs.lfo_to_osc1gain = ControlSpec.BIPOLAR
specs.lfo_to_osc2gain = ControlSpec.BIPOLAR
specs.lfo_to_osc3gain = ControlSpec.BIPOLAR
specs.envattack = ControlSpec.new(0, 5000, "linear", 0, 5, "ms")
specs.envdecay = ControlSpec.new(0, 5000, "linear", 0, 400, "ms")
specs.envsustain = ControlSpec.new(0, 1, "linear", 0, 0.5, "")
specs.envrelease = ControlSpec.new(0, 5000, "linear", 0, 400, "ms")
specs.envcurve = ControlSpec.new(-20, 20, "linear", 0, -4, "")
specs.env_to_osc1freq = ControlSpec.BIPOLAR
specs.env_to_osc1gain = ControlSpec.BIPOLAR
specs.env_to_osc2freq = ControlSpec.BIPOLAR
specs.env_to_osc2gain = ControlSpec.BIPOLAR
specs.env_to_osc3freq = ControlSpec.BIPOLAR
specs.env_to_osc3gain = ControlSpec.BIPOLAR
specs.env_to_filtercutoff = ControlSpec.BIPOLAR
specs.env_to_filterres = ControlSpec.BIPOLAR
specs.env_to_ampgain = ControlSpec.BIPOLAR

Gong.specs = specs

local function bind(paramname, id, formatter)
  params:add_control(paramname, specs[id], formatter)
  params:set_action(paramname, engine[id])
  --[[
  params:set_action(paramname, function(value)
    print(value)
    engine[id](value)
  end)
  ]]
end

function Gong.add_params()
  local numoscs = 3

  bind("timbre", "timbre", Formatters.percentage)
  bind("timemod", "timemod", Formatters.percentage)

  for oscnum=1,numoscs do
    bind("osc"..oscnum.." gain", "osc"..oscnum.."gain", Formatters.percentage)

    params:add_option("osc"..oscnum.." type", {"partial", "fixed"})
    params:set_action("osc"..oscnum.." type", function(value)
      if value == 1 then
        engine["osc"..oscnum.."fixed"](0)
      else
        engine["osc"..oscnum.."fixed"](1)
      end
    end)

    bind("osc"..oscnum.." partial no", "osc"..oscnum.."partial")
    bind("osc"..oscnum.." fixed freq", "osc"..oscnum.."fixedfreq")
    bind("osc"..oscnum.." index", "osc"..oscnum.."index")
    bind("osc"..oscnum.." > amp", "osc"..oscnum.."outlevel", Formatters.percentage)

    for src=1,numoscs do
      bind("osc"..src.." > osc"..oscnum.." freq", "osc"..src.."_to_osc"..oscnum.."freq", Formatters.percentage)
    end

    bind( "env > osc"..oscnum.." freq", "env_to_osc"..oscnum.."freq", Formatters.percentage)
    bind( "env > osc"..oscnum.." gain", "env_to_osc"..oscnum.."gain", Formatters.percentage)
    bind( "lfo > osc"..oscnum.." freq", "lfo_to_osc"..oscnum.."freq", Formatters.percentage)
    bind( "lfo > osc"..oscnum.." gain", "lfo_to_osc"..oscnum.."gain", Formatters.percentage)
  end

  bind("env attack", "envattack")
  bind("env decay", "envdecay")
  bind("env sustain", "envsustain")
  bind("env release", "envrelease")
  bind("env curve", "envcurve")
  bind("filter cutoff", "filtercutoff")
  bind("filter resonance", "filterres", Formatters.percentage)
  params:add_option("filter mode", {"lowpass", "bandpass", "highpass", "notch", "peak"})
  params:set_action("filter mode", function(value) engine.filtermode(value-1) end)
  bind("amp gain", "ampgain", Formatters.percentage)
  bind("lfo rate", "lforate", Formatters.round(3))
  bind("lfo > filter cutoff", "lfo_to_filtercutoff", Formatters.percentage)
  bind("lfo > filter resonance", "lfo_to_filterres", Formatters.percentage)
  bind("lfo > amp gain", "lfo_to_ampgain", Formatters.percentage)
  bind("env > amp gain", "env_to_ampgain", Formatters.percentage)
  bind("env > filter cutoff", "env_to_filtercutoff", Formatters.percentage)
  bind("env > filter resonance", "env_to_filterres", Formatters.percentage)
end

return Gong
