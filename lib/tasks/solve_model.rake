desc 'Solves a run'
# task :solve_run, [:run_id] => :environment do |_task, args|
#   run = Run.find(args.run_id)
#   logger = Logger.new("/tmp/run-#{args.run_id}.log")
#   SolveRun.new(run: run, logger: logger).call
# end

task :solve_cbc_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  log_path = "/tmp/run-#{args.run_id}.log"
  logger = Logger.new(log_path)
  begin
    SolveRun.new(run: run, logger: logger, solver_class: Osemosys::SolveCbcModel).call
  ensure
    run.update_attributes(finished_at: Time.current) if run.finished_at.nil?
    run.log_file.attach(
      io: File.open(log_path),
      filename: File.basename(log_path)
    )
  end
end
