namespace :metrics do
  desc 'Collect new data for metrics'
  task update: :environment do
    Metric.register(User::METRIC_COUNT, User.count)
    Metric.register(Dream::METRIC_COUNT, Dream.count)
    Metric.register(Comment::METRIC_COUNT, Comment.count)
    Metric.register(Pattern::METRIC_COUNT, Pattern.count)
    Metric.register(Pattern::METRIC_DESCRIBED, Pattern.described(1).count)
    Metric.register(Word::METRIC_COUNT, Word.count)
    Metric.register(Word::METRIC_PROCESSED, Word.processed(1).count)
  end
end
