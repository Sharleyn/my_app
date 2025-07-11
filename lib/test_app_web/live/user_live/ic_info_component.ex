defmodule TestAppWeb.UserLive.ICInfoComponent do
  use TestAppWeb, :live_component

  @origin_codes %{
    "01" => "Johor",
    "02" => "Kedah",
    "03" => "Kelantan",
    "04" => "Melaka",
    "05" => "Negeri Sembilan",
    "06" => "Pahang",
    "07" => "Penang",
    "08" => "Perak",
    "09" => "Perlis",
    "10" => "Selangor",
    "11" => "Terengganu",
    "12" => "Sabah",
    "13" => "Sarawak"
  }

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(%{"number" => ""}, as: :ic))
     |> assign(:origin, nil)
     |> assign(:gender, nil)
     |> assign(:error, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Analyze IC Info for {@user.name}</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ic-info-form"
        phx-target={@myself}
        phx-change="analyze"
        phx-submit="close"
      >
        <.input field={@form[:number]} type="text" label="IC Number" placeholder="e.g. 010927121234" />

        <div :if={@error} class="mt-4 text-red-500 font-medium">
          <%= @error %>
        </div>

        <div :if={@origin && @gender} class="mt-6 p-4 bg-gray-50 rounded-lg">
          <h3 class="text-lg font-semibold text-gray-900 mb-2">IC Info</h3>
          <div class="text-base">
            <p><strong>Origin:</strong> <%= @origin %></p>
            <p><strong>Gender:</strong> <%= @gender %></p>
          </div>
        </div>

        <:actions>
          <.button type="submit">Close</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("analyze", %{"ic" => %{"number" => number}}, socket) do
    case parse_ic(number) do
      {:ok, origin, gender} ->
        {:noreply,
         socket
         |> assign(:origin, origin)
         |> assign(:gender, gender)
         |> assign(:error, nil)
         |> assign(:form, to_form(%{"number" => number}, as: :ic))}

      {:error, msg} ->
        {:noreply,
         socket
         |> assign(:origin, nil)
         |> assign(:gender, nil)
         |> assign(:error, msg)
         |> assign(:form, to_form(%{"number" => number}, as: :ic))}
    end
  end

  def handle_event("close", _params, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.patch)}
  end

  defp parse_ic(ic) do
    ic_str = String.trim(ic)

    cond do
     String.length(ic_str) != 12 ->
        {:error, "IC must be exactly 12 digits"}

      ic_str =~ ~r/[^0-9]/ ->
        {:error, "IC must contain only digits"}

      true ->
        origin_code = String.slice(ic_str, 6, 2)
        last_digit = String.at(ic_str, -1) |> String.to_integer()

        origin = Map.get(@origin_codes, origin_code, "Unknown")
        gender = if rem(last_digit, 2) == 0, do: "Female", else: "Male"

        {:ok, origin, gender}
    end
  end
end
