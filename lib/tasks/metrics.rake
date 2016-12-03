namespace :metrics do
  desc 'Collect new data for metrics'
  task update: :environment do
    Metric.register("#{User.table_name}.count", User.count)
    Metric.register("#{Dream::table_name}.count", Dream.count)
    Metric.register("#{Comment::table_name}.count", Comment.count)
    Metric.register("#{Pattern::table_name}.count", Pattern.count)
    Metric.register(Pattern::METRIC_DESCRIBED, Pattern.described(1).count)
    Metric.register("#{Word::table_name}.count", Word.count)
    Metric.register(Word::METRIC_PROCESSED, Word.processed(1).count)
    Metric.register("#{Filler::table_name}.count", Filler.count)
  end
end
