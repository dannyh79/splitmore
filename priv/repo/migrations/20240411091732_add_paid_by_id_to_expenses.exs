defmodule Splitmore.Repo.Migrations.AddPaidByIdToExpenses do
  use Ecto.Migration

  def up do
    alter table(:expenses) do
      add :paid_by_id, references(:users, type: :uuid, on_delete: :nothing)
    end

    execute("UPDATE expenses SET paid_by_id = user_id WHERE paid_by_id IS NULL")

    alter table(:expenses) do
      modify :paid_by_id, :uuid, null: false
    end
  end

  def down do
    alter table(:expenses) do
      remove :paid_by_id
    end
  end
end
