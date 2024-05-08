defmodule Splitmore.Repo.Migrations.AddRoleToGroupsUsers do
  use Ecto.Migration

  def change do
    alter table(:groups_users) do
      add :role, :integer, null: false, default: 0
    end
  end
end
