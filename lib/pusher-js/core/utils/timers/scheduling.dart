// ignore_for_file: non_constant_identifier_names, prefer_generic_function_type_aliases

@JS()
library core.utils.timers.scheduling;

import "package:js/js.dart";

typedef num Scheduler(TimedCallback, number);
typedef void Canceller(number); /*export type Delay = number;*/
