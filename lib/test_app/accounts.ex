defmodule TestApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TestApp.Repo

  alias TestApp.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
  def user_gender(%User{gender: gender}) do
    case gender do
      "male" -> "User is male"
      "female" -> "User is female"
      _ -> "Unknown gender"
    end
  end

  def user_age_range(%User{age: age}) when age < 18 do
    "User is a minor"
  end

  def user_age_range(%User{age: age}) when age >= 18 and age <= 65 do
    "User is an adult"
  end

  def user_age_range(_user) do
    "Unknown age range"
  end

  def user_details(%User{} = user) do
    user_gender(user) <> " " <> user_age_range(user)
  end

  def format_user_name(%User{name: name}) do
    name |>String.upcase() |>String.replace(" ","_")
  end

  def user_ic_info(user_ic_number) when rem(user_ic_number/2) == 0 do
    "Female"
  end

  def user_ic_info(_user) do
    "Male"
  end

  def user_ic_info(%User{} = user) do
    state_code = %{"01" => "Johor", "02" => "Kedah", "03" => "Kelantan", "04" => "Melaka", "05" => "Negeri Sembilan", "06" => "Pahang", "07" => "Pulau Pinang", "08" => "Perak", "09" => "Perlis", "10" => "Selangor", "11" => "Terengganu", "12" => "Sabah", "13" => "Sarawak", "14" => "W.P. Kuala Lumpur", "15" => "W.P. Labuan", "16" => "W.P. Putrajaya"}

  end
end
