namespace :queue do
  desc "Advance fillers queue"
  task advance: :environment do
    filler = Filler.first
    unless filler.nil?
      filler.apply
      filler.destroy if filler.applied?
    end
  end
end
