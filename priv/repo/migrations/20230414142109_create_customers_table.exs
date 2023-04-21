defmodule CarLeasing.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :email, :string, unique: true
      add :password, :string

      timestamps()
    end
  end
end
