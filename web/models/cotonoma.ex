defmodule Cotoami.Cotonoma do
  @moduledoc """
  コトの間 (Cotonoma) is a space for chatting and weaving Cotos.
  """
  
  use Cotoami.Web, :model
  
  @key_length 10

  schema "cotonomas" do
    field :key, :string
    field :name, :string
    belongs_to :coto, Cotoami.Coto    # nil means home (root)
    belongs_to :owner, Cotoami.Owner
    has_many :cotos, Cotoami.Coto

    timestamps()
  end

  def changeset_new(struct, params \\ %{}) do
    struct
    |> cast(params, [:owner_id, :name])
    |> generate_key
    |> validate_required([:owner_id, :key])
  end
  
  defp generate_key(changeset) do
    key = :crypto.strong_rand_bytes(@key_length) |> Base.hex_encode32(case: :lower)
    changeset |> put_change(:key, key)
  end
  
  def query_home(amishi_id) do
    from c in __MODULE__,
      where: c.owner_id == ^amishi_id and is_nil(c.coto_id)
  end
end