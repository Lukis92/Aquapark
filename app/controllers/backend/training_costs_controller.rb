# Controller For TrainingCost actions
class Backend::TrainingCostsController < BackendController
  before_action :set_training_cost, only: [:edit, :update, :destroy]
  def index
    @training_costs = TrainingCost.paginate(page: params[:page],
                                            per_page: 20).order('duration ASC')
  end

  # GET backend/training_costs/new
  def new
    @training_cost = TrainingCost.new
  end

  # POST backend/training_costs
  def create
    @training_cost = TrainingCost.new(training_cost_params)

    respond_to do |format|
      if @training_cost.save
        format.html { redirect_to backend_training_costs_path, notice: 'Pomyślnie dodano.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/training_costs/1
  def update
    respond_to do |format|
      if @training_cost.update(training_cost_params)
        format.html { redirect_to backend_training_costs_path, notice: 'Pomyślnie zaktualizowano.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE backend/training_costs/1
  # DELETE backend/training_costs/1.json
  def destroy
    @training_cost.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Pomyślnie usunięto.' }
    end
  end

  private

  def set_training_cost
    @training_cost = TrainingCost.find(params[:id])
  end

  def training_cost_params
    params.require(:training_cost).permit(:duration, :cost)
  end
end
