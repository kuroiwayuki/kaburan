# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :memo

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :validate_unique_name_in_memo

  # 商品名を正規化（全角→半角、カタカナ→ひらがな、空白削除）
  def self.normalize_name(name)
    return "" if name.blank?

    normalized = name.to_s
    # 全角英数字を半角に変換
    normalized = normalized.tr('０-９Ａ-Ｚａ-ｚ', '0-9A-Za-z')
    # カタカナをひらがなに変換
    normalized = normalized.tr('ァ-ヶ', 'ぁ-ゖ')
    # 空白を削除
    normalized = normalized.gsub(/\s+/, '')
    # 小文字に統一
    normalized.downcase
  end

  private

  def validate_unique_name_in_memo
    return if name.blank? || memo.nil?

    normalized_name = self.class.normalize_name(name)

    # 同じメモ内で、自分以外に同じ正規化された名前のアイテムがあるかチェック
    duplicate_items = memo.items.reject { |item| item == self || item.marked_for_destruction? }

    duplicate_items.each do |item|
      if self.class.normalize_name(item.name) == normalized_name
        errors.add(:name, "「#{name}」は既にこのメモに追加されています")
        break
      end
    end
  end
end

