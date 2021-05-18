defmodule Ecto.Integration.Migration do
  use Ecto.Migration

  def change do
    # IO.puts "TESTING MIGRATION LOCK"
    # Process.sleep(10000)

    create table(:users, comment: "users table") do
      add :name, :string, comment: "name column"
      add :custom_id, :uuid
      timestamps()
    end

    create table(:posts) do
      add :title, :string, size: 100
      add :counter, :integer
      add :blob, :binary
      add :bid, :binary_id
      add :uuid, :uuid
      add :meta, :map
      add :links, {:map, :string}
      add :intensities, {:map, :float}
      add :public, :boolean
      add :cost, :decimal, precision: 2, scale: 1
      add :visits, :integer
      add :wrapped_visits, :integer
      add :intensity, :float
      add :author_id, :integer
      add :posted, :date
      add :composite_a, :integer
      add :composite_b, :integer
      timestamps(null: true)
    end

    create table(:posts_users, primary_key: false) do
      add :post_id, references(:posts)
      add :user_id, references(:users)
    end

    create table(:posts_users_pk) do
      add :post_id, references(:posts)
      add :user_id, references(:users)
      timestamps()
    end

    # Add a unique index on uuid. We use this
    # to verify the behaviour that the index
    # only matters if the UUID column is not NULL.
    create unique_index(:posts, [:uuid], comment: "posts index")

    create table(:permalinks) do
      add :uniform_resource_locator, :string
      add :title, :string
      add :post_id, references(:posts)
      add :user_id, references(:users)
    end

    create unique_index(:permalinks, [:post_id])
    create unique_index(:permalinks, [:uniform_resource_locator])

    create table(:comments) do
      add :text, :string, size: 100
      add :lock_version, :integer, default: 1
      add :post_id, references(:posts)
      add :author_id, references(:users)
    end

    create table(:customs, primary_key: false) do
      add :bid, :binary_id, primary_key: true
      add :uuid, :uuid
    end

    create unique_index(:customs, [:uuid])

    create table(:customs_customs, primary_key: false) do
      add :custom_id1, references(:customs, column: :bid, type: :binary_id)
      add :custom_id2, references(:customs, column: :bid, type: :binary_id)
    end

    create table(:barebones) do
      add :num, :integer
    end

    create table(:transactions) do
      add :num, :integer
    end

    create table(:lock_counters) do
      add :count, :integer
    end

    create table(:orders) do
      add :item, :map
      add :items, :map
      add :meta, :map
      add :permalink_id, references(:permalinks)
    end

    unless :array_type in ExUnit.configuration()[:exclude] do
      create table(:tags) do
        add :ints,  {:array, :integer}
        add :uuids, {:array, :uuid}, default: []
        add :items, {:array, :map}
      end
    end

    create table(:composite_pk, primary_key: false) do
      add :a, :integer, primary_key: true
      add :b, :integer, primary_key: true
      add :name, :string
    end

    create table(:composite_pk_composite_pk, primary_key: false) do
      add :b_1, :integer
      add :a_1, references(:composite_pk, column: :a, with: [b_1: :b], type: :integer)
      add :b_2, :integer
      add :a_2, references(:composite_pk, column: :a, with: [b_2: :b], type: :integer)
    end


    alter table(:posts) do
      modify :composite_a, references(:composite_pk, column: :a, with: [composite_b: :b], type: :integer)
    end

    create table(:posts_composite_pk) do
      add :post_id, references(:posts), primary_key: true
      add :composite_a, references(:composite_pk, column: :a, with: [composite_b: :b], type: :integer), primary_key: true
      add :composite_b, :integer, primary_key: true
    end

    create unique_index(:posts_composite_pk, [:post_id, :composite_a, :composite_b])

    create table(:corrupted_pk, primary_key: false) do
      add :a, :string
    end

    create table(:posts_users_composite_pk) do
      add :post_id, references(:posts), primary_key: true
      add :user_id, references(:users), primary_key: true
      timestamps()
    end

    create unique_index(:posts_users_composite_pk, [:post_id, :user_id])

    create table(:usecs) do
      add :naive_datetime_usec, :naive_datetime_usec
      add :utc_datetime_usec, :utc_datetime_usec
    end

    create table(:bits) do
      add :bit, :bit
    end
  end
end
