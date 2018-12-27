desc 'Solves a run'
task :solve_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  logger = Logger.new("./log/run-#{args.run_id}.log")
  SolveRun.new(run: run, logger: logger).call
end

task :solve_cplex_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  logger = Logger.new("./log/run-#{args.run_id}.log")
  SolveRun.new(run: run, logger: logger, use_cplex: true).call
end
