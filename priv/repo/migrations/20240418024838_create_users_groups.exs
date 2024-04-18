defmodule Splitmore.Repo.Migrations.CreateUsersGroups do
  use Ecto.Migration

  def change do
    create table(:groups_users, primary_key: false) do
      add :group_id, references(:groups, type: :uuid, on_delete: :delete_all)
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
    end

    create index(:groups_users, [:group_id])
    create index(:groups_users, [:user_id])
    create unique_index(:groups_users, [:group_id, :user_id])
  end
end
