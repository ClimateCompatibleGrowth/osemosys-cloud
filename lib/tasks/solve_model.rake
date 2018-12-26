desc 'Solves a run'
task :solve_run, [:run_id] => :environment do |_task, args|
  run = Run.find(args.run_id)
  SolveRun.new(run: run).call
end
