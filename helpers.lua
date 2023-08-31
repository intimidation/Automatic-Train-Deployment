--declare local variables for frequently used functions
local math_random = math.random
local table_remove = table.remove
local table_insert = table.insert
local util_distance = util.distance

--randomize the schedule of a train with weights
function public.randomize_schedule(train, weights)
  --get the current schedule
  local schedule = train.schedule
  --check if the schedule is valid and has at least two records
  if schedule and schedule.records and #schedule.records >= 2 then
    --create a new table to store the randomized records
    local randomized_records = {}
    --create a copy of the original records
    local original_records = table.deepcopy(schedule.records)
    --calculate sum of weights
    local weight_sum = 0
    for i, weight in ipairs(weights) do
      weight_sum = weight_sum + weight
    end
    --calculate percentages per 100 trains
    local percentages = {}
    for i, weight in ipairs(weights) do
      table_insert(percentages, weight / weight_sum * 100)
    end
    --create table with start and end percentages for each weight
    local ranges = {}
    local start_percentage = 0
    for i, percentage in ipairs(percentages) do
      local range = {}
      range.start_percentage = start_percentage
      range.end_percentage = start_percentage + percentage
      start_percentage = range.end_percentage
      table_insert(ranges, range)
    end
    --loop until all original records are moved to the randomized table
    while #original_records > 0 do
      --generate a random number between 0 and 100
      local random_number = math_random(0, 100)
      --loop through ranges table and find index of first entry whose start percentage is less than or equal to random number and whose end percentage is greater than or equal to random number.
      local index = nil
      for i, range in ipairs(ranges) do
        if range.start_percentage <= random_number and range.end_percentage >= random_number then
          index = i
          break
        end
      end
      --remove the record at that index from original records and insert it to randomized records.
      if index then 
        local record = table_remove(original_records, index)
        table_insert(randomized_records, record)
        --remove corresponding weight from weights table.
        table_remove(weights, index)
      end 
    end 
    --set the new records as the train schedule.
    schedule.records = randomized_records 
    train.schedule = schedule 
    --return true to indicate success.
    return true 
  else 
    --return false to indicate failure.
    return false 
  end 
end

--get the length of a train's rail segment in tiles (rounded down)
function public.get_train_length(train)
  return math.floor(train.get_rail_segment_length() / 2)
end

--get a table of all items and fluids in a train's cargo wagons and fluid wagons (keys are names, values are counts or amounts)
function public.get_train_contents(train)
  return train.get_contents()
end

--get the signal that is stopping a train (if any)
function public.get_train_stopped_signal(train)
  return train.get_stopped_signal()
end

--check if a train has finished its schedule (returns true or false)
function public.is_train_schedule_finished(train)
  return train.schedule_finished()
end

--check if a train has a path to its destination (if any) (returns true or false)
function public.does_train_have_path(train)
  return train.has_path or false --return false if has_path is nil (train is not moving)
end

--get the current speed of a train in km/hour (rounded to one decimal place)
function public.get_train_speed(train)
  return math.floor(train.speed * 3600 / 1000 * 10 + 0.5) / 10 --convert m/s to km/h and round to one decimal place
end

--create a message with variables using string formatting functions (returns a string)
function public.create_message(format_string, ...)
  return string.format(format_string, ...)
end

