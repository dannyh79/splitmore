defmodule Splitmore.Repo.Migrations.AddGroupIdToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :group_id, references(:groups, type: :uuid, on_delete: :nothing)
    end

    create index(:expenses, [:group_id])
  end
end
