import Foundation
import Combine
import Chat
import WalletConnectUtils

typealias Stream<T> = AsyncPublisher<AnyPublisher<T, Never>>

final class ChatService {

    static let selfAccount = Account("eip155:1:0xab16a96d359ec26a11e2c2b3d8f8b8942d5bfcdb")!

    private let client: ChatClient

    init(client: ChatClient) {
        self.client = client
    }

    var messagePublisher: Stream<Message> {
        return client.messagePublisher.values
    }

    var threadPublisher: Stream<Chat.Thread> {
        return client.newThreadPublisher.values
    }

    var invitePublisher: Stream<Invite> {
        return client.invitePublisher.values
    }

    func getMessages(thread: Chat.Thread) async -> [Chat.Message] {
        await client.getMessages(topic: thread.topic)
    }

    func getThreads() async -> [Chat.Thread] {
        await client.getThreads()
    }

    func getInvites(account: Account) async -> [Chat.Invite] {
        client.getInvites(account: account)
    }

    func sendMessage(topic: String, message: String) async throws {
        try await client.message(topic: topic, message: message)
    }

    func accept(invite: Invite) async throws {
        try await client.accept(inviteId: invite.pubKey)
    }

    func reject(invite: Invite) async throws {
        try await client.reject(inviteId: invite.pubKey)
    }

    func invite(peerPubkey publicKey: String, peerAccount: Account, message: String, selfAccount: Account) async throws {
        try await client.invite(publicKey: publicKey, peerAccount: peerAccount, openingMessage: message, account: selfAccount)
    }
}
