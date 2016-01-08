# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2016, Sebastian Staudt

describe MultiTag do

  let(:library) { double }
  let(:tag_names) { %w{tag-1 tag2} }

  let(:tag1) { mock_model Tag, name: 'Tag 1', simple_name: 'tag-1' }
  let(:tag2) { mock_model Tag, name: 'Tag 2', simple_name: 'tag-2' }

  let(:distinct_photos) { double }
  let(:tagged_photos) { double }

  before do
    tags = double
    allow(tags).to receive(:where).with(simple_name: tag_names) { [ tag1, tag2 ] }
    allow(library).to receive(:tags) { tags }

    tag_photos = double
    allow(tag_photos).to receive(:where).with(RKKeywordForVersion: { keywordId: [ tag1.id, tag2.id ] }) do
      tagged_photos
    end
    allow(distinct_photos).to receive(:joins).with(:tag_photos) { tag_photos }
    allow(library).to receive(:photos) { double distinct: distinct_photos }
  end

  context 'using any of its tags' do

    let(:all_tagged_photos) { double }

    before do
      @multi_tag = MultiTag.new library, tag_names, false
    end

    it 'should have a combined name' do
      expect(@multi_tag.name).to eq('Tag 1, Tag 2')
    end

    it 'should have a combined simple name' do
      expect(@multi_tag.simple_name).to eq('tag-1,tag-2')
    end

    it 'should contain the photos that have at least one of the tags' do
      expect(@multi_tag.photos).to eq(tagged_photos)
    end

  end

  context 'using the intersection of its tags' do

    let(:all_tagged_photos) { double }

    before do
      @multi_tag = MultiTag.new library, tag_names, true

      tag_photos = double
      tag_photo = class_double(TagPhoto).as_stubbed_const
      unique_tags = double
      allow(tag_photo).to receive(:select).with(:modelId) { tag_photos }
      allow(tag_photos).to receive(:group).with(:keywordId, :versionId) { unique_tags }
      allow(tagged_photos).to receive(:where).with(RKKeywordForVersion: { modelId: unique_tags }) { tagged_photos }
      allow(tagged_photos).to receive(:group).with(:versionId) { tagged_photos }
      allow(tagged_photos).to receive(:having).with('count(versionId) = ?', 2) { all_tagged_photos }
    end

    it 'should have a combined name' do
      expect(@multi_tag.name).to eq('Tag 1 & Tag 2')
    end

    it 'should have a combined simple name' do
      expect(@multi_tag.simple_name).to eq('tag-1+tag-2')
    end

    it 'should contain the photos that have all tags' do
      expect(@multi_tag.photos).to eq(all_tagged_photos)
    end

  end

end
