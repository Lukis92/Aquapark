class Backend::StatisticsController < BackendController
    def index
        @all_people = Person.all.count
        @employees = Person.all.where.not(type: 'Client').count
        @lifeguards = Lifeguard.all.count
        @recptionists = Receptionist.all.count
        @trainers = Trainer.all.count
        @clients = Client.all.count

        @sum_salaries = Person.sum(:salary)
        @sum_earnings = EntryType.joins(:bought_details).sum(:price)
        @sum_risk = @sum_earnings - @sum_salaries
    end
end
