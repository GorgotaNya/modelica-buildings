within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences;
block Alarms "Generate alarms of parallel fan-powered terminal unit with variable-volume fan"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (__cdl(ValueInReference=false));
  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real hotWatRes
    "Importance multiplier for the hot water reset control loop"
    annotation (Dialog(enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real lowFloTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=true));
  parameter Real lowTemTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check low discharge temperature"
    annotation (__cdl(ValueInReference=true), Dialog(enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real comChaTim(
    final unit="s",
    final quantity="Time")=15
    "Threshold time after fan command change"
    annotation (__cdl(ValueInReference=true));
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off"
    annotation (__cdl(ValueInReference=true));
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow"
    annotation (__cdl(ValueInReference=true));
  parameter Real valCloTim(
    final unit="s",
    final quantity="Time")=900
    "Threshold time to check valve leaking water flow"
    annotation (__cdl(ValueInReference=true));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")=0.05
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real staTim(
    final unit="s",
    final quantity="Time")=1800
    "Delay triggering alarms after enabling AHU supply fan"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,390},{-240,430}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,310},{-240,350}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FanCom
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1TerFan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final unit="1")
    "Actual valve position"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-280,-250},{-240,-210}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-280,-290},{-240,-250}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,-330},{-240,-290}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge air temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-370},{-240,-330}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,330},{280,370}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFanStaAla
    "Fan status alarm"
    annotation (Placement(transformation(extent={{240,70},{280,110}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-80},{280,-40}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-390},{280,-350}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,370},{-180,390}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,400},{-140,420}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,400},{-60,420}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,320},{-160,340}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,290},{-180,310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,400},{-20,420}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,400},{160,420}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,440},{100,460}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,320},{100,340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,230},{160,250}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,340},{220,360}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,400},{20,420}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{80,360},{100,380}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{140,360},{160,380}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{80,280},{100,300}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{140,280},{160,300}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the measured airflow is greater than the threshold and the AHU supply fan is OFF"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Less les1(
    final h=dTHys) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-320},{-100,-300}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-17) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Reals.Less les2(
    final h=dTHys) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-390},{-100,-370}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(final p=-8.3)
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-430},{-160,-410}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=lowTemTim) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=lowTemTim) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-40,-390},{-20,-370}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature has been less than threshold and the hot water plant is proven on"
    annotation (Placement(transformation(extent={{-80,-320},{-60,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical not"
    annotation (Placement(transformation(extent={{80,-360},{100,-340}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: discharge air temperature is 17 degC less than the setpoint.")
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 2 low discharge air temperature alarm"
    annotation (Placement(transformation(extent={{140,-360},{160,-340}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowTemAla if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge temperature alarm"
    annotation (Placement(transformation(extent={{140,-320},{160,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and8 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature has been less than threshold and the hot water plant is proven on"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,-390},{100,-370}})));
  Buildings.Controls.OBC.CDL.Logical.And and9 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{0,-390},{20,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical not"
    annotation (Placement(transformation(extent={{80,-430},{100,-410}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: discharge air temperature is 8 degC less than the setpoint.")
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{140,-430},{160,-410}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt3(
    final k=hotWatRes) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Importance multiplier for hot water reset control"
    annotation (Placement(transformation(extent={{-120,-460},{-100,-440}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,-460},{-60,-440}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,-460},{160,-440}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-380},{220,-360}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=valCloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloVal(
    final t=valPosHys,
    final h=0.5*valPosHys)
    "Check if valve position is near zero"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=3)
    "AHU supply temperature plus 3 degree"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2(
    final h=dTHys)
    "Discharge temperature greate than AHU supply temperature by a threshold"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And leaValAla
    "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not8 "Logical not"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes6(
    final message="Warning: the valve is leaking.")
    "Level 4 leaking valve alarm"
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=comChaTim)
    "Check if the terminal fan has been commond on for threshold time"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    "Check if the fan has been commond on for threshold time and fan is still off"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch fanStaAla
    "Fan status alarm"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not9
    "Logical not"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel8(
    final delayTime=comChaTim)
    "Check if the terminal fan has been commond off for threshold time"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "Check if the fan has been commond off for threshold time and fan is still on"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7(
    final integerTrue=4)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not10
    "Logical not"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes7(
    final message="Warning: fan has been commanded ON but still OFF.")
    "Level 2 fan status alarm"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not11
    "Logical not"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes8(
    final message="Warning: fan has been commanded OFF but still ON.")
    "Level 4 fan status alarm"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not12
    "Logical not"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel9(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,320},{-100,340}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay fanIni(
    final delayTime=staTim)
    "Check if the AHU supply fan has been enabled for threshold time"
    annotation (Placement(transformation(extent={{-180,230},{-160,250}})));
  Buildings.Controls.OBC.CDL.Logical.And and12
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,270},{-100,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and13
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,400},{-100,420}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and14
    "Logical and"
    annotation (Placement(transformation(extent={{40,320},{60,340}})));
  Buildings.Controls.OBC.CDL.Logical.And and15
    "Logical and"
    annotation (Placement(transformation(extent={{40,400},{60,420}})));
  Buildings.Controls.OBC.CDL.Logical.And and16
    "Check if the fan has been commond on for threshold time and fan is still off"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and17
    "Check if the fan has been commond off for threshold time and fan is still on"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla1
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And leaValAla1
    "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and18 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{40,-390},{60,-370}})));
  Buildings.Controls.OBC.CDL.Logical.And and19 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{40,-320},{60,-300}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,330},{-220,330},{
          -220,380},{-202,380}}, color={0,0,127}));
  connect(VPri_flow, les.u1)
    annotation (Line(points={{-260,410},{-162,410}}, color={0,0,127}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,330},{-182,330}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,330},{-220,330},
          {-220,300},{-202,300}}, color={0,0,127}));
  connect(VPri_flow, gre.u2) annotation (Line(points={{-260,410},{-230,410},{
          -230,272},{-162,272}}, color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-178,300},{-170,300},{-170,
          280},{-162,280}}, color={0,0,127}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,410},{-42,410}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,280},{-50,280},{-50,
          322},{-42,322}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,450},{120,450},{
          120,418},{138,418}}, color={255,127,0}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,330},{120,330},
          {120,402},{138,402}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,240},{-82,240}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,240},{138,240}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,410},{180,410},{
          180,356},{198,356}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,240},{180,240},{
          180,344},{198,344}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{102,370},{138,370}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,410},{-2,410}},
                          color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,240},{-10,240},{-10,
          402},{-2,402}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,330},{-2,330}},
                    color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,240},{-10,240},{-10,
          322},{-2,322}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{102,290},{138,290}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,180},{-162,180}}, color={0,0,127}));
  connect(u1Fan, not3.u)
    annotation (Line(points={{-260,140},{-202,140}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,180},{-120,180},{-120,
          192},{-102,192}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,200},{-42,200}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{82,170},{98,170}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,200},{260,200}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,350},{260,350}}, color={255,127,0}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-110},{-202,-110}}, color={0,0,127}));
  connect(u1Fan, leaDamAla.u2) annotation (Line(points={{-260,140},{-220,140},{-220,
          -68},{-42,-68}},color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{142,-100},{158,-100}}, color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,-60},{260,-60}}, color={255,127,0}));
  connect(VPri_flow, gre1.u1) annotation (Line(points={{-260,410},{-230,410},{-230,
          200},{-102,200}}, color={0,0,127}));
  connect(TDis, les1.u1)
    annotation (Line(points={{-260,-310},{-122,-310}}, color={0,0,127}));
  connect(TDisSet, addPar.u)
    annotation (Line(points={{-260,-350},{-182,-350}}, color={0,0,127}));
  connect(addPar.y, les1.u2) annotation (Line(points={{-158,-350},{-140,-350},{-140,
          -318},{-122,-318}}, color={0,0,127}));
  connect(TDis, les2.u1) annotation (Line(points={{-260,-310},{-220,-310},{-220,
          -380},{-122,-380}}, color={0,0,127}));
  connect(TDisSet, addPar1.u) annotation (Line(points={{-260,-350},{-200,-350},{
          -200,-420},{-182,-420}}, color={0,0,127}));
  connect(addPar1.y, les2.u2) annotation (Line(points={{-158,-420},{-140,-420},{
          -140,-388},{-122,-388}}, color={0,0,127}));
  connect(conInt2.y, lowTemAla.u1) annotation (Line(points={{102,-270},{120,-270},
          {120,-302},{138,-302}}, color={255,127,0}));
  connect(not6.y, assMes4.u)
    annotation (Line(points={{102,-350},{138,-350}}, color={255,0,255}));
  connect(booToInt4.y, lowTemAla.u3) annotation (Line(points={{102,-380},{120,-380},
          {120,-318},{138,-318}}, color={255,127,0}));
  connect(not7.y, assMes5.u)
    annotation (Line(points={{102,-420},{138,-420}}, color={255,0,255}));
  connect(conInt3.y, greThr2.u)
    annotation (Line(points={{-98,-450},{-82,-450}}, color={0,0,127}));
  connect(greThr2.y, booToInt5.u)
    annotation (Line(points={{-58,-450},{138,-450}}, color={255,0,255}));
  connect(lowTemAla.y, proInt1.u1) annotation (Line(points={{162,-310},{180,-310},
          {180,-364},{198,-364}}, color={255,127,0}));
  connect(booToInt5.y, proInt1.u2) annotation (Line(points={{162,-450},{180,-450},
          {180,-376},{198,-376}}, color={255,127,0}));
  connect(greThr2.y, and7.u2) annotation (Line(points={{-58,-450},{-10,-450},{-10,
          -318},{-2,-318}}, color={255,0,255}));
  connect(greThr2.y, and9.u2) annotation (Line(points={{-58,-450},{-10,-450},{-10,
          -388},{-2,-388}}, color={255,0,255}));
  connect(proInt1.y, yLowTemAla)
    annotation (Line(points={{222,-370},{260,-370}}, color={255,127,0}));
  connect(uVal, cloVal.u)
    annotation (Line(points={{-260,-160},{-202,-160}}, color={0,0,127}));
  connect(TSup, addPar2.u)
    annotation (Line(points={{-260,-230},{-202,-230}}, color={0,0,127}));
  connect(TDis, gre2.u1) annotation (Line(points={{-260,-310},{-220,-310},{-220,
          -210},{-142,-210}}, color={0,0,127}));
  connect(addPar2.y, gre2.u2) annotation (Line(points={{-178,-230},{-160,-230},{
          -160,-218},{-142,-218}}, color={0,0,127}));
  connect(u1Fan, leaValAla.u2) annotation (Line(points={{-260,140},{-220,140},{-220,
          -188},{-42,-188}},color={255,0,255}));
  connect(not8.y, assMes6.u)
    annotation (Line(points={{122,-220},{138,-220}}, color={255,0,255}));
  connect(booToInt6.y, yLeaValAla)
    annotation (Line(points={{162,-180},{260,-180}}, color={255,127,0}));
  connect(u1FanCom, truDel7.u)
    annotation (Line(points={{-260,60},{-162,60}}, color={255,0,255}));
  connect(u1FanCom, not9.u) annotation (Line(points={{-260,60},{-200,60},{-200,-10},
          {-182,-10}}, color={255,0,255}));
  connect(not9.y, truDel8.u)
    annotation (Line(points={{-158,-10},{-42,-10}},  color={255,0,255}));
  connect(u1FanCom, and11.u2) annotation (Line(points={{-260,60},{-200,60},{-200,
          82},{-42,82}}, color={255,0,255}));
  connect(not9.y, and10.u2) annotation (Line(points={{-158,-10},{-140,-10},{-140,
          12},{-42,12}}, color={255,0,255}));
  connect(conInt4.y, fanStaAla.u1) annotation (Line(points={{102,130},{120,130},
          {120,98},{138,98}}, color={255,127,0}));
  connect(booToInt7.y, fanStaAla.u3) annotation (Line(points={{102,20},{120,20},
          {120,82},{138,82}}, color={255,127,0}));
  connect(fanStaAla.y, yFanStaAla)
    annotation (Line(points={{162,90},{260,90}}, color={255,127,0}));
  connect(not10.y, assMes7.u)
    annotation (Line(points={{102,60},{138,60}}, color={255,0,255}));
  connect(not11.y, assMes8.u)
    annotation (Line(points={{102,-20},{138,-20}}, color={255,0,255}));
  connect(u1TerFan, not12.u) annotation (Line(points={{-260,20},{-210,20},{-210,
          110},{-162,110}}, color={255,0,255}));
  connect(u1TerFan, and10.u1) annotation (Line(points={{-260,20},{-210,20},{-210,
          20},{-42,20}}, color={255,0,255}));
  connect(not12.y, and11.u1) annotation (Line(points={{-138,110},{-80,110},{-80,
          90},{-42,90}}, color={255,0,255}));
  connect(greThr.y, truDel9.u)
    annotation (Line(points={{-158,330},{-122,330}}, color={255,0,255}));
  connect(truDel9.y, and1.u1)
    annotation (Line(points={{-98,330},{-42,330}}, color={255,0,255}));
  connect(truDel9.y, and2.u2) annotation (Line(points={{-98,330},{-50,330},{-50,
          402},{-42,402}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-178,140},{-50,140},{-50,192},
          {-42,192}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{-18,200},{-2,200}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{22,200},{50,200},{50,170},
          {58,170}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{22,200},{138,200}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{82,-60},{138,-60}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{82,-60},{100,-60},{100,-100},
          {118,-100}},color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,200},{-60,200},{-60,
          -60},{-42,-60}}, color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{62,-180},{138,-180}}, color={255,0,255}));
  connect(truDel6.y, not8.u) annotation (Line(points={{62,-180},{80,-180},{80,-220},
          {98,-220}}, color={255,0,255}));
  connect(cloVal.y, leaValAla.u1) annotation (Line(points={{-178,-160},{-60,-160},
          {-60,-180},{-42,-180}}, color={255,0,255}));
  connect(and6.y, truDel4.u)
    annotation (Line(points={{-58,-310},{-42,-310}}, color={255,0,255}));
  connect(and8.y, truDel5.u)
    annotation (Line(points={{-58,-380},{-42,-380}}, color={255,0,255}));
  connect(les2.y, and8.u1)
    annotation (Line(points={{-98,-380},{-82,-380}}, color={255,0,255}));
  connect(les1.y, and6.u1)
    annotation (Line(points={{-98,-310},{-82,-310}}, color={255,0,255}));
  connect(truDel4.y, and7.u1) annotation (Line(points={{-18,-310},{-2,-310}},
                            color={255,0,255}));
  connect(truDel5.y, and9.u1) annotation (Line(points={{-18,-380},{-2,-380}},
                      color={255,0,255}));
  connect(u1HotPla, and6.u2) annotation (Line(points={{-260,-270},{-90,-270},{-90,
          -318},{-82,-318}}, color={255,0,255}));
  connect(u1HotPla, and8.u2) annotation (Line(points={{-260,-270},{-90,-270},{-90,
          -388},{-82,-388}}, color={255,0,255}));
  connect(les.y, and13.u1)
    annotation (Line(points={{-138,410},{-122,410}}, color={255,0,255}));
  connect(and13.y, truDel.u)
    annotation (Line(points={{-98,410},{-82,410}}, color={255,0,255}));
  connect(gre.y, and12.u1)
    annotation (Line(points={{-138,280},{-122,280}}, color={255,0,255}));
  connect(and12.y, truDel1.u)
    annotation (Line(points={{-98,280},{-82,280}}, color={255,0,255}));
  connect(u1Fan, fanIni.u) annotation (Line(points={{-260,140},{-220,140},{-220,
          240},{-182,240}}, color={255,0,255}));
  connect(fanIni.y, and13.u2) annotation (Line(points={{-158,240},{-130,240},{-130,
          402},{-122,402}}, color={255,0,255}));
  connect(fanIni.y, and12.u2) annotation (Line(points={{-158,240},{-130,240},{
          -130,272},{-122,272}}, color={255,0,255}));
  connect(uOpeMod, isOcc.u1) annotation (Line(points={{-260,-40},{-122,-40}},
                 color={255,127,0}));
  connect(occMod.y, isOcc.u2) annotation (Line(points={{-138,-90},{-130,-90},{-130,
          -48},{-122,-48}}, color={255,127,0}));
  connect(gai.y, les.u2) annotation (Line(points={{-178,380},{-170,380},{-170,
          402},{-162,402}}, color={0,0,127}));
  connect(and15.y, lowFloAla.u2)
    annotation (Line(points={{62,410},{138,410}}, color={255,0,255}));
  connect(and3.y, and15.u1)
    annotation (Line(points={{22,410},{38,410}}, color={255,0,255}));
  connect(and15.y, not1.u) annotation (Line(points={{62,410},{70,410},{70,370},{
          78,370}}, color={255,0,255}));
  connect(and14.y, booToInt.u)
    annotation (Line(points={{62,330},{78,330}}, color={255,0,255}));
  connect(and4.y, and14.u1)
    annotation (Line(points={{22,330},{38,330}}, color={255,0,255}));
  connect(isOcc.y, and15.u2) annotation (Line(points={{-98,-40},{30,-40},{30,402},
          {38,402}}, color={255,0,255}));
  connect(isOcc.y, and14.u2) annotation (Line(points={{-98,-40},{30,-40},{30,322},
          {38,322}}, color={255,0,255}));
  connect(and11.y, and16.u1)
    annotation (Line(points={{-18,90},{-2,90}}, color={255,0,255}));
  connect(and16.y, fanStaAla.u2)
    annotation (Line(points={{22,90},{138,90}}, color={255,0,255}));
  connect(and10.y, and17.u1)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));
  connect(and17.y, booToInt7.u)
    annotation (Line(points={{22,20},{78,20}}, color={255,0,255}));
  connect(and16.y, not10.u) annotation (Line(points={{22,90},{60,90},{60,60},{78,
          60}}, color={255,0,255}));
  connect(and17.y, not11.u) annotation (Line(points={{22,20},{60,20},{60,-20},{78,
          -20}}, color={255,0,255}));
  connect(truDel7.y, and16.u2) annotation (Line(points={{-138,60},{-10,60},{-10,
          82},{-2,82}}, color={255,0,255}));
  connect(leaDamAla.y, leaDamAla1.u1)
    annotation (Line(points={{-18,-60},{-2,-60}}, color={255,0,255}));
  connect(leaDamAla1.y, truDel3.u)
    annotation (Line(points={{22,-60},{58,-60}}, color={255,0,255}));
  connect(cloDam.y, leaDamAla1.u2) annotation (Line(points={{-178,-110},{-10,-110},
          {-10,-68},{-2,-68}}, color={255,0,255}));
  connect(leaValAla.y, leaValAla1.u1)
    annotation (Line(points={{-18,-180},{-2,-180}}, color={255,0,255}));
  connect(leaValAla1.y, truDel6.u)
    annotation (Line(points={{22,-180},{38,-180}}, color={255,0,255}));
  connect(gre2.y, leaValAla1.u2) annotation (Line(points={{-118,-210},{-10,-210},
          {-10,-188},{-2,-188}}, color={255,0,255}));
  connect(truDel8.y, and17.u2) annotation (Line(points={{-18,-10},{-10,-10},{-10,
          12},{-2,12}}, color={255,0,255}));
  connect(and7.y, and19.u1)
    annotation (Line(points={{22,-310},{38,-310}}, color={255,0,255}));
  connect(and19.y, lowTemAla.u2)
    annotation (Line(points={{62,-310},{138,-310}}, color={255,0,255}));
  connect(and19.y, not6.u) annotation (Line(points={{62,-310},{70,-310},{70,-350},
          {78,-350}}, color={255,0,255}));
  connect(and18.y, booToInt4.u)
    annotation (Line(points={{62,-380},{78,-380}}, color={255,0,255}));
  connect(and9.y, and18.u1)
    annotation (Line(points={{22,-380},{38,-380}}, color={255,0,255}));
  connect(and18.y, not7.u) annotation (Line(points={{62,-380},{70,-380},{70,-420},
          {78,-420}}, color={255,0,255}));
  connect(isOcc.y, and19.u2) annotation (Line(points={{-98,-40},{30,-40},{30,-318},
          {38,-318}}, color={255,0,255}));
  connect(isOcc.y, and18.u2) annotation (Line(points={{-98,-40},{30,-40},{30,-388},
          {38,-388}}, color={255,0,255}));
  connect(and14.y, not2.u) annotation (Line(points={{62,330},{70,330},{70,290},
          {78,290}}, color={255,0,255}));
annotation (defaultComponentName="ala",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-98,92},{-48,78}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-100,102},{-60,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,-4},{-74,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,74},{-80,64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{46,98},{96,84}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,68},{98,54}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,-12},{98,-26}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{-100,-24},{-78,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-100,-44},{-74,-54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-64},{-66,-76}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
          textString="u1HotPla"),
        Text(
          extent={{-100,-80},{-76,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-102,-92},{-64,-102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet",
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{48,-42},{98,-56}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{42,-82},{98,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla",
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{-98,56},{-58,42}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1FanCom"),
        Text(
          extent={{48,30},{98,16}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFanStaAla"),
        Text(
          extent={{-96,34},{-66,22}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1TerFan"),
        Text(
          extent={{-98,16},{-48,2}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-480},{240,480}})),
Documentation(info="<html>
<p>
This block outputs alarms of parallel fan-powered terminal unit with variable volume fan.
The implementation is according to the Section 5.8.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
<ol>
<li>
After the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow <code>VPri_flow</code> is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
After the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow <code>VPri_flow</code> is less than 50% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 2 alarm.
</li>
<li>
If a zone has an importance multiplier (<code>staPreMul</code>) of 0 for its
static pressure reset Trim-Respond control loop, low airflow alarms shall be
suppressed for that zone.
</li>
</ol>
<h4>Low-discharging air temperature</h4>
<ol>
<li>
If heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 8.3 &deg;C (15 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 3 alarm.
</li>
<li>
If heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 17 &deg;C (30 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 2 alarm.
</li>
<li>
If a zone has an importance multiplier (<code>hotWatRes</code>) of 0 for its
hot-water reset Trim-Respond control loop, low discharing air temperature alarms
shall be suppressed for that zone.
</li>
</ol>
<h4>Fan status alarm</h4>
<p>
Fan alarm is indicated by the status input being different from the output command
after a period of 15 seconds after a change in output status.
</p>
<ol>
<li>
Command on (<code>u1FanCom=true</code>), status off (<code>u1TerFan=false</code>),
generate Level 2 alarm.
</li>
<li>
Command off (<code>u1FanCom=false</code>), status on (<code>u1TerFan=true</code>),
generate Level 4 alarm.
</li>
</ol>
<h4>Airflow sensor calibration</h4>
<p>
If the fan serving the zone has been OFF (<code>u1Fan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and airflow sensor reading <code>VPri_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</p>
<h4>Leaking damper</h4>
<p>
If the damper position (<code>uDam</code>) is 0% and airflow sensor reading
<code>VPri_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>u1Fan=true</code>), generate a Level
4 alarm.
</p>
<h4>Leaking valve</h4>
<p>
If the valve position (<code>uVal</code>) is 0% for 15 minutes (<code>valCloTim</code>),
discharing air temperature <code>TDis</code> is above AHU supply temperature
<code>TSup</code> by 3 &deg;C (5 &deg;F), and the fan serving the zone is proven
on (<code>u1Fan=true</code>), gemerate a Level 4 alarm.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2023, by Hongxiang Fu:<br/>
Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
replaced it with a stack of two <code>Logical.And</code> blocks.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
</li>
<li>
August 23, 2023, by Jianjun Hu:<br/>
Added delay <code>staTim</code> to allow the system becoming stablized.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
