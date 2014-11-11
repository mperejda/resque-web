module ResqueWeb
  class WorkersController < ApplicationController
    before_filter :display_subtabs

    def index
    end

    def show
      if params[:id] && params[:id] != 'all'
        @workers = view_context.worker_hosts[params[:id]].map { |id| Resque::Worker.find(id) }
      else
        @workers = Resque.workers
      end
    end

    #kills all workers on a given host
    def destroy
      @workers = Resque.workers
      @workers.each { |worker| worker.unregister_worker}
      redirect_to workers_path
    end

    #kills worker by by worker id
    def kill_worker
      Resque::Worker.find(params[:id]).unregister_worker
      redirect_to workers_path
    end

    private

    def display_subtabs
      set_subtabs view_context.worker_hosts.map(&:first)
    end

  end
end
