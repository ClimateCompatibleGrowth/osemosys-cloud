desc 'Solves a run'

task :solve_cbc_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  log_path = run.local_log_path
  logger = Logger.new(log_path)
  Osemosys::Config.config.logger = logger
  Osemosys::Config.config.run_id = run.id
  SolveRun.new(
    run: run,
    solver: Osemosys::Solvers::Cbc,
  ).call
end
