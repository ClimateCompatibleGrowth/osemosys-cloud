desc 'Solves a run'

task :solve_cbc_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  log_path = run.local_log_path
  logger = Logger.new(log_path)
  SolveRun.new(
    run: run,
    solver: Osemosys::Solvers::Cbc,
    logger: logger,
  ).call

  if File.exist?(log_path) && !run.log_file.attached?
    run.log_file.attach(
      io: File.open(log_path),
      filename: File.basename(log_path),
    )
  end
end
