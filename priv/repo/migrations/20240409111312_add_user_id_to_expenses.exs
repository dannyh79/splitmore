defmodule Splitmore.Repo.Migrations.AddUserIdToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false
    end
  end
end
