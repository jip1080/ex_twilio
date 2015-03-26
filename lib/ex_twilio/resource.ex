defmodule ExTwilio.Resource do
  @doc """
  Provide a `use` macro for use extending.
  """
  defmacro __using__(options) do
    import_functions  = options[:import] || []
    quote bind_quoted: [import_functions: import_functions] do
      alias ExTwilio.Api

      module = String.replace(to_string(__MODULE__), ~r/Elixir\./, "")

      if Enum.member? import_functions, :all do
        @doc """
        Retrieve _all_ of the #{module} records from the Twilio API, paging
        through all the API response pages.

        ## Examples

            {:ok, list} = #{module}.all
            {:error, msg, http_code} = #{module}.all
        """
        def all, do: Api.all(__MODULE__)
      end

      if Enum.member? import_functions, :list do
        @doc """
        Retrieve a list of %#{module}{} from the API. 

        ## Examples

            {:ok, list, metadata} = #{module}.list
            {:error, msg, http_code} = #{module}.list
        """
        def list(options \\ []), do: Api.list(__MODULE__, options)

        @doc """
        Get the next page of items, using the metadata from the previous
        response. See `all/0` for an easy way to get all the records.

        ## Examples

            {:ok, page1, meta} = #{module}.list
            {:ok, page2, meta} = #{module}.next_page(meta)
        """
        def next_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["next_page_uri"])
        end

        @doc """
        Get the previous page of items, using metadata from a previous response.

        ## Examples

            {:ok, page2, meta} = #{module}.list(page: 2)
            {:ok, page1, meta} = #{module}.previous_page(meta)
        """
        def previous_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["previous_page_uri"])
        end

        @doc """
        Get the first page of items, using metadata from any page's response.

        ## Examples

            {:ok, page10, meta} = #{module}.list(page: 10)
            {:ok, page1, meta}  = #{module}.first_page(meta)
        """
        def first_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["first_page_uri"])
        end

        @doc """
        Get the last page of items, using metadta from any page's response.

        ## Examples
            
            {:ok, page10, meta}    = #{module}.list(page: 10)
            {:ok, last_page, meta} = #{module}.last_page(meta)
        """
        def last_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["last_page_uri"])
        end
      end

      if Enum.member? import_functions, :find do
        @doc """
        Find an %#{module}{} by its Twilio SID.

        ## Examples

            {:ok, item} = #{module}.find("...")
            {:error, msg, http_status} = #{module}.find("...")
        """
        def find(sid), do: Api.find(__MODULE__, sid)
      end

      if Enum.member? import_functions, :create do
        @doc """
        Create a new %#{module}{} in the Twilio API. Any option supported by this
        Resource can be passed in the 'data' keyword list. See Twilio's 
        documentation for this resource for more details.
        """
        def create(data), do: Api.create(__MODULE__, data)
      end

      if Enum.member? import_functions, :update do
        @doc """
        Update an %#{module}{} in the Twilio API. You can pass it a binary SID as
        the identifier, or a whole %#{module}{}.

        ## Examples

            {:ok, item} = #{module}.update(%#{module}{...}, field: "new_value")
            {:ok, item} = #{module}.update("<SID HERE>", field: "new_value")
        """
        def update(sid, data), do: Api.update(__MODULE__, sid, data)
      end

      if Enum.member? import_functions, :destroy do
        @doc """
        Delete a %#{module}{} from your Twilio account.
        """
        def destroy(sid), do: Api.destroy(__MODULE__, sid)
      end
    end
  end
end
