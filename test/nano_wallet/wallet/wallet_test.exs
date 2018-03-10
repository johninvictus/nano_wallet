defmodule NanoWallet.WalletTest do
  use NanoWallet.DataCase

  alias NanoWallet.Wallet

  describe "wallet_accounts" do
    alias NanoWallet.Wallet.WalletAccount

    @valid_attrs %{currency: "some currency", name: "some name", type: "some type"}
    @update_attrs %{currency: "some updated currency", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{currency: nil, name: nil, type: nil}

    def wallet_account_fixture(attrs \\ %{}) do
      {:ok, wallet_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wallet.create_wallet_account()

      wallet_account
    end

    test "list_wallet_accounts/0 returns all wallet_accounts" do
      wallet_account = wallet_account_fixture()
      assert Wallet.list_wallet_accounts() == [wallet_account]
    end

    test "get_wallet_account!/1 returns the wallet_account with given id" do
      wallet_account = wallet_account_fixture()
      assert Wallet.get_wallet_account!(wallet_account.id) == wallet_account
    end

    test "create_wallet_account/1 with valid data creates a wallet_account" do
      assert {:ok, %WalletAccount{} = wallet_account} = Wallet.create_wallet_account(@valid_attrs)
      assert wallet_account.currency == "some currency"
      assert wallet_account.name == "some name"
      assert wallet_account.type == "some type"
    end

    test "create_wallet_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_wallet_account(@invalid_attrs)
    end

    test "update_wallet_account/2 with valid data updates the wallet_account" do
      wallet_account = wallet_account_fixture()
      assert {:ok, wallet_account} = Wallet.update_wallet_account(wallet_account, @update_attrs)
      assert %WalletAccount{} = wallet_account
      assert wallet_account.currency == "some updated currency"
      assert wallet_account.name == "some updated name"
      assert wallet_account.type == "some updated type"
    end

    test "update_wallet_account/2 with invalid data returns error changeset" do
      wallet_account = wallet_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallet.update_wallet_account(wallet_account, @invalid_attrs)
      assert wallet_account == Wallet.get_wallet_account!(wallet_account.id)
    end

    test "delete_wallet_account/1 deletes the wallet_account" do
      wallet_account = wallet_account_fixture()
      assert {:ok, %WalletAccount{}} = Wallet.delete_wallet_account(wallet_account)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_wallet_account!(wallet_account.id) end
    end

    test "change_wallet_account/1 returns a wallet_account changeset" do
      wallet_account = wallet_account_fixture()
      assert %Ecto.Changeset{} = Wallet.change_wallet_account(wallet_account)
    end
  end

  describe "wallet_entries" do
    alias NanoWallet.Wallet.WalletEntry

    @valid_attrs %{amount: "some amount", description: "some description", type: "some type"}
    @update_attrs %{amount: "some updated amount", description: "some updated description", type: "some updated type"}
    @invalid_attrs %{amount: nil, description: nil, type: nil}

    def wallet_entry_fixture(attrs \\ %{}) do
      {:ok, wallet_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wallet.create_wallet_entry()

      wallet_entry
    end

    test "list_wallet_entries/0 returns all wallet_entries" do
      wallet_entry = wallet_entry_fixture()
      assert Wallet.list_wallet_entries() == [wallet_entry]
    end

    test "get_wallet_entry!/1 returns the wallet_entry with given id" do
      wallet_entry = wallet_entry_fixture()
      assert Wallet.get_wallet_entry!(wallet_entry.id) == wallet_entry
    end

    test "create_wallet_entry/1 with valid data creates a wallet_entry" do
      assert {:ok, %WalletEntry{} = wallet_entry} = Wallet.create_wallet_entry(@valid_attrs)
      assert wallet_entry.amount == "some amount"
      assert wallet_entry.description == "some description"
      assert wallet_entry.type == "some type"
    end

    test "create_wallet_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_wallet_entry(@invalid_attrs)
    end

    test "update_wallet_entry/2 with valid data updates the wallet_entry" do
      wallet_entry = wallet_entry_fixture()
      assert {:ok, wallet_entry} = Wallet.update_wallet_entry(wallet_entry, @update_attrs)
      assert %WalletEntry{} = wallet_entry
      assert wallet_entry.amount == "some updated amount"
      assert wallet_entry.description == "some updated description"
      assert wallet_entry.type == "some updated type"
    end

    test "update_wallet_entry/2 with invalid data returns error changeset" do
      wallet_entry = wallet_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallet.update_wallet_entry(wallet_entry, @invalid_attrs)
      assert wallet_entry == Wallet.get_wallet_entry!(wallet_entry.id)
    end

    test "delete_wallet_entry/1 deletes the wallet_entry" do
      wallet_entry = wallet_entry_fixture()
      assert {:ok, %WalletEntry{}} = Wallet.delete_wallet_entry(wallet_entry)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_wallet_entry!(wallet_entry.id) end
    end

    test "change_wallet_entry/1 returns a wallet_entry changeset" do
      wallet_entry = wallet_entry_fixture()
      assert %Ecto.Changeset{} = Wallet.change_wallet_entry(wallet_entry)
    end
  end
end
