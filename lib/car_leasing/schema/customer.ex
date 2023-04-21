defmodule CarLeasing.Customer do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :first_name, :last_name, :phone_number, :email]}
  schema "customers" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :email, :string
    field :password, :string

    has_many :leases, CarLeasing.Lease

    timestamps()
  end

  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:first_name, :last_name, :phone_number, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "must be a valid email address"
    )
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
    |> unique_constraint(:email)
    |> put_password_hash()
    |> unique_constraint(:password)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
